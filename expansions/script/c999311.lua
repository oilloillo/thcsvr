--✿红叶与丰收的象征✿
function c999311.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c999311.ffilter1,c999311.ffilter2,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c999311.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c999311.spcon)
	e2:SetOperation(c999311.spop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999311,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c999311.eqcost)
	e3:SetTarget(c999311.eqtg)
	e3:SetOperation(c999311.eqop)
	c:RegisterEffect(e3)
end
c999311.DescSetName = 0xa2
function c999311.ffilter1(c)
	return c:IsCode(999301) or c:IsCode(23001)
end

function c999311.ffilter2(c)
	return c:IsCode(999302) or c:IsCode(23004)
end

function c999311.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

function c999311.spfilter1(c,tp)
	return (c:IsCode(999301) or c:IsCode(23001)) and c:IsCanBeFusionMaterial()
		and Duel.CheckReleaseGroup(tp,c999311.spfilter2,1,c)
end

function c999311.spfilter2(c)
	return (c:IsCode(999302) or c:IsCode(23004)) and c:IsCanBeFusionMaterial()
end

function c999311.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c999311.spfilter1,1,nil,tp)
end

function c999311.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c999311.spfilter1,1,1,nil,tp)
	local g2=Duel.SelectReleaseGroup(tp,c999311.spfilter2,1,1,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST)
end

function c999311.eqfilter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName == 0xa2 and c:IsType(TYPE_SPELL) and not c:IsType(TYPE_CONTINUOUS)
end

function c999311.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end

function c999311.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c999311.eqfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end

function c999311.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	
	if not Duel.IsExistingMatchingCard(c999311.eqfilter, tp, LOCATION_DECK, 0, 1, nil) then
		return 
	end
	if not Duel.IsExistingMatchingCard(Card.IsFaceup, tp, LOCATION_MZONE, 0, 1, nil) then
		return
	end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eq=Duel.SelectMatchingCard(tp, c999311.eqfilter, tp, LOCATION_DECK, 0, 1, 1, nil):GetFirst()

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp, Card.IsFaceup, tp, LOCATION_MZONE, 0, 1, 1, nil):GetFirst()

	if not Duel.Equip(tp,eq,tc,true) then return end

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c999311.eqlimit)
	eq:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999311,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c999311.actcon)
	e2:SetCost(c999311.actcost)
	e2:SetTarget(c999311.acttg)
	e2:SetOperation(c999311.actop)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	eq:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	e3:SetValue(1)
	eq:RegisterEffect(e3)
end

function c999311.eqlimit(e,c)
	return true
end

function c999311.actcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and a==e:GetHandler():GetEquipTarget()) or (d and d==e:GetHandler():GetEquipTarget())
end

function c999311.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckActivateEffect(false,true,false)~=nil end
	local te=c:CheckActivateEffect(false,true,true)
	c999311[Duel.GetCurrentChain()]=te
end

function c999311.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=c999311[Duel.GetCurrentChain()]
	if chkc then
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,true)
	end
	if chk==0 then return true end
	if not te then return end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end

function c999311.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local te=c999311[Duel.GetCurrentChain()]
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end