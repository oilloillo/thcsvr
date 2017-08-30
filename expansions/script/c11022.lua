--鬼王✿矜羯罗
function c11022.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11022,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c11022.spcost)
	e1:SetTarget(c11022.sptg)
	e1:SetOperation(c11022.spop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11022,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c11022.damcon)
	e2:SetTarget(c11022.damtg)
	e2:SetOperation(c11022.damop)
	c:RegisterEffect(e2)
end
function c11022.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c11022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11021,0,0x4011,2700,700,9,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c11022.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,11021,0,0x4011,2700,700,9,RACE_ZOMBIE,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,11021)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(11021,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c11022.destg)
	e1:SetOperation(c11022.desop)
	token:RegisterEffect(e1)
	Duel.SpecialSummonComplete()
end
function c11022.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if c~=Duel.GetAttacker() then return false end
	if chk==0 then return tc~=0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function c11022.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc and c:IsRelateToBattle() then Duel.Destroy(c,REASON_EFFECT) end
end
function c11022.ifilter(c)
	return c:IsFaceup() and c:IsCode(11021)
end
function c11022.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c11022.ifilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c11022.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c11022.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
