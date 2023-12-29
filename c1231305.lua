--Number 39: Utopia (Deck Master)
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	if not DeckMaster then
		return
	end
	--Deck Master Effect
	local dme1=Effect.CreateEffect(c)
	dme1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	dme1:SetCode(EVENT_BE_BATTLE_TARGET)
	dme1:SetCondition(s.dmcon)
	dme1:SetOperation(s.dmop)
	DeckMaster.RegisterAbilities(c,dme1)
	--Xyz Summon
	Xyz.AddProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--Disable attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCost(aux.dxmcostgen(1,1,nil))
	e1:SetOperation(function() Duel.NegateAttack() end)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
	--Self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
s.xyz_number=39
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttackTarget()==c and c:GetOverlayCount()==0
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function s.dmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local dm=Duel.GetDeckMaster(tp)
	return Duel.IsDeckMaster(tp,id) and Duel.GetAttackTarget():IsControler(tp) and dm
		and (dm:IsLocation(LOCATION_MZONE) or Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and dm:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.dmop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then return end
	local c=e:GetOwner()
	if not c:IsLocation(LOCATION_MZONE) then return end
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Hint(HINT_CARD,1-tp,id)
	Duel.NegateAttack()
	Duel.BreakEffect()
	Duel.SummonDeckMaster(tp)
end